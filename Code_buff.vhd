VIRTUAL_ADC_1 : process(SCLK, CS(0))
    variable SAMPLE_CNT : INTEGER := 0;
    variable TEST_DATA  : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) := (others => '0');
begin
    -- 1. Срабатываем СТРОГО В МОМЕНТ, когда чип выбрали (спад CS: '1' -> '0')
    if falling_edge(CS(0)) then
        SAMPLE_CNT := SAMPLE_CNT + 1;

        if SAMPLE_CNT = 1 then
            TEST_DATA := X"005000"; -- Самый первый ответ - честный ID чипа!
        elsif (SAMPLE_CNT MOD 2 = 0) then
            TEST_DATA := X"000300"; -- Обычный замер А
        else
            TEST_DATA := X"000100"; -- Обычный замер Б
        end if;

    -- 2. Когда CS поднят ('1') - отпускаем шину в третье состояние (Hi-Z)
    elsif CS(0) = '1' then
        MISO(0) <= 'Z';

    -- 3. Выталкиваем биты по спаду SCLK во время активного CS
    elsif falling_edge(SCLK) then
        MISO(0)   <= TEST_DATA(DATA_WIDTH-1);
        TEST_DATA := TEST_DATA(DATA_WIDTH-2 DOWNTO 0) & '0';
    end if;
end process VIRTUAL_ADC_1;