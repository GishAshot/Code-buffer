imp_FIRST_START : process (CLK) is
begin
    if rising_edge(CLK) then
        if (RST = '0') then
            FIRST_START <= '0';
            
        -- ВЗВОДИМ FIRST_START ТОЛЬКО ТОГДА, КОГДА ПРОВЕРКА ID УЖЕ ЗАКОНЧИЛАСЬ:
        -- (DEV_CHANGED был в 1, и пришел SPI_RDY)
        elsif (FIRST_START_EN = '1') and (DEV_CHANGED = '1') and (SPI_RDY = '1') then
            FIRST_START <= '1';
            
        -- СБРАСЫВАЕМ FIRST_START ТОЛЬКО ПОСЛЕ ТОГО, КАК УЛЕТЕЛА КОМАНДА 0x010300:
        elsif (FIRST_START = '1') and (SPI_RDY = '1') then
            FIRST_START <= '0';
        end if;
    end if;
end process;