elsif (STEPS_CNT = STEPS_NUMBER - 1) and (DATA_RDY_SIG = '1') then
    FIRST_START_EN <= '0';




imp_FIRST_START : process (CLK) is
begin
    if rising_edge(CLK) then
        if (RST = '0') then
            FIRST_START <= '0';
        -- 1. Взводим флаг пробуждения СРАЗУ ПОСЛЕ того, как проверили ID:
        elsif (FIRST_START_EN = '1') and (DEV_CHANGED = '1') and (SPI_RDY = '1') then
            FIRST_START <= '1';
            
        -- 2. Сбрасываем флаг пробуждения, как только команда 0x010300 ушла в SPI:
        elsif (FIRST_START = '1') and (SPI_RDY = '1') then
            FIRST_START <= '0';
        end if;
    end if;
end process;