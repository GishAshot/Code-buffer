VIRTUAL_ADC_1 : process(SCLK, CS(0))
    variable SAMPLE_CNT : integer := 0;
    variable TOGGLE     : boolean := false; -- Флажок чередования
    variable TEST_DATA  : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
begin
    -- 1. Срабатываем СТРОГО в момент падения CS (начало посылки):
    if falling_edge(CS(0)) then
        SAMPLE_CNT := SAMPLE_CNT + 1;
        
        -- Самый первый ответ - паспорт ID:
        if SAMPLE_CNT = 1 then
            TEST_DATA := X"005000";
            
        -- На все остальные замеры ЧЕРЕДУЕМ ДАННЫЕ через флаг TOGGLE:
        elsif TOGGLE = false then
            TEST_DATA := X"000300"; -- Первое значение
            TOGGLE    := true;
        else
            TEST_DATA := X"000FF0"; -- ВТОРОЕ ЗНАЧЕНИЕ! Теперь оно гарантированно вылетит!
            TOGGLE    := false;
        end if;

    -- 2. Когда CS не наш - отпускаем шину в Hi-Z:
    elsif CS(0) = '1' then
        MISO(0) <= 'Z';

    -- 3. Сдвигаем биты ТОЛЬКО ТОГДА, КОГДА НАШ ЧИП АКТИВЕН (CS=0)!
    elsif falling_edge(SCLK) and CS(0) = '0' then  -- ДОБАВЛЕНА ПРОВЕРКА CS=0!
        MISO(0)   <= TEST_DATA(DATA_WIDTH-1);
        TEST_DATA := TEST_DATA(DATA_WIDTH-2 downto 0) & '0';
    end if;
end process VIRTUAL_ADC_1;