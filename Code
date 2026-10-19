-- Внутренние флаги и состояния:
signal is_first_start : std_logic := '1'; -- Флаг первого запуска после сброса
signal dev_prev       : integer range 0 to 1 := 0;

-- Состояния автомата:
type t_state is (
    ST_IDLE,
    ST_WAKEUP,          -- Отправка 0x010300
    ST_CHECK_ID,        -- Отправка 0x0F0000
    ST_SET_CHANNEL,     -- Отправка команды смены канала
    ST_WAIT_SETTLE,     -- Пауза 102 мс
    ST_READ_DATA,       -- Отправка 0x440000
    ST_WAIT_SAMPLE      -- Пауза 51 мс
);
signal state : t_state := ST_IDLE;
process(CLK)
begin
    if rising_edge(CLK) then
        if RST = '1' then
            state          <= ST_IDLE;
            is_first_start <= '1';
            dev_prev       <= 0;
            spi_start      <= '0';
            adc_mosi       <= (others => '0');
        else
            case state is

                when ST_IDLE =>
                    -- Проверяем: первый ли это старт?
                    if is_first_start = '1' then
                        adc_mosi       <= X"010300"; -- Сначала будим АЦП
                        spi_start      <= '1';
                        state          <= ST_WAKEUP;
                        is_first_start <= '0';

                    -- Или устройство изменилось?
                    elsif current_device /= dev_prev then
                        adc_mosi       <= X"0F0000"; -- Читаем ID нового чипа
                        spi_start      <= '1';
                        state          <= ST_CHECK_ID;
                        dev_prev       <= current_device; -- Запоминаем

                    -- Обычный рабочий режим: пора переключать канал
                    elsif need_change_channel = '1' then
                        adc_mosi       <= w_channel_lut_data; -- Из таблицы ROM
                        spi_start      <= '1';
                        state          <= ST_SET_CHANNEL;

                    -- Пора читать очередную точку (одну из 16)
                    elsif need_read_sample = '1' then
                        adc_mosi       <= X"440000"; -- Читаем замер
                        spi_start      <= '1';
                        state          <= ST_READ_DATA;
                    end if;

                when ST_WAKEUP =>
                    spi_start <= '0';
                    if spi_rdy = '1' then
                        state <= ST_IDLE; -- Разбудили, возвращаемся в выбор действий
                    end if;

                when ST_CHECK_ID =>
                    spi_start <= '0';
                    if spi_rdy = '1' then
                        -- Здесь проверяем ответ ID (байты ответа с MISO)
                        if spi_rx_data(15 downto 12) = X"5" then
                            state <= ST_IDLE; -- ID сошелся, продолжаем
                        else
                            state <= ST_IDLE; -- Авария (или ветка ошибки)
                        end if;
                    end if;

                -- Остальные состояния (SET_CHANNEL, WAIT_SETTLE, READ_DATA)...
                when others =>
                    state <= ST_IDLE;
            end case;
        end if;
    end if;
end process;