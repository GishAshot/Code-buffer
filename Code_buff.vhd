imp_WAKEUP_CTRL : process (CLK) is
begin
    if rising_edge(CLK) then
        -- 1. При сбросе ОБА чипа помечены как спящие ("11"):
        if (RST = '0') then
            WAKEUP_NEEDED <= (others => '1');
            
        -- 2. Сбрасываем флаг сна ТОЛЬКО ДЛЯ ТЕКУЩЕГО ЧИПА,
        --    когда команда 0x010300 реально улетела по SPI (пришел SPI_RDY):
        elsif (DEV_CHANGED = '0') and (CURRENT_WAKEUP = '1') and (SPI_RDY = '1') then
            WAKEUP_NEEDED(conv_integer(DEV_SIG)) <= '0';
        end if;
    end if;
end process;