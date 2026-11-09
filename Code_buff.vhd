imp_DEVICES_WOKEN : process (CLK) is
    variable dev_idx : integer range 0 to SLAVE_NUMBER-1;
begin
    if rising_edge(CLK) then
        -- 1. При сбросе (RST='0') или если сработал детектор аварии (ADC_ERR_SIG='1'):
        -- Сбрасываем чек-лист в "00" (все чипы снова требуют пробуждения!):
        if (RST = '0') or (ADC_ERR_SIG = '1') then
            DEVICES_WOKEN <= (others => '0');
            https://disk.yandex.ru/d/bjxVApaKhFH9FA
        -- 2. Фиксируем успешную отправку команды пробуждения:
        -- (SPI закончил передачу, и на шине MOSI была именно команда 0x010300)
        elsif (SPI_RDY = '1') and (ADC_MOSI = X"010300") then
            dev_idx := conv_integer(DEV_SIG);
            DEVICES_WOKEN(dev_idx) <= '1'; -- Чип dev_idx официально проснулся!
        end if;
    end if;
end process;