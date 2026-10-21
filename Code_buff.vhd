VIRTUAL_ADC_1 : process(SCLK, CS(0))
    variable SAMPLE_CNT : INTEGER := 0;
    variable TEST_DATA  : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) := (others => '0');
begin
    if CS(0) = '1' then
        -- Когда CS поднят, подготавливаем данные на следующий замер:
        SAMPLE_CNT := SAMPLE_CNT + 1;
        
        -- САМАЯ ВАЖНАЯ ПРАВКА:
        if SAMPLE_CNT = 1 then
            -- Первый ответ обязан быть паспортом чипа (ID):
            TEST_DATA := X"005000"; 
        elsif (SAMPLE_CNT MOD 2 = 0) then
            TEST_DATA := X"000300";
        else
            TEST_DATA := X"000100";
        end if;

    elsif falling_edge(SCLK) then
        MISO(0)   <= TEST_DATA(DATA_WIDTH-1);
        TEST_DATA := TEST_DATA(DATA_WIDTH-2 DOWNTO 0) & '0';
    end if;
end process VIRTUAL_ADC_1;