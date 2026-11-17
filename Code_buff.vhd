VIRTUAL_ADC_1 : process
        variable rx_word : std_logic_vector(23 downto 0) := (others => '0');
        variable tx_word : std_logic_vector(23 downto 0) := (others => '0');
        variable chan_id : integer := 0;
    begin
        MISO(0) <= 'Z';
        
        -- Ждем, когда ПЛИС выберет Чип 0:
        wait until falling_edge(CS(0));

        -- Пока чип выбран:
        while CS(0) = '0' loop
            -- 1. Принимаем 8 бит команды по нарастающему фронту SCLK:
            for i in 23 downto 16 loop
                wait until rising_edge(SCLK) or rising_edge(CS(0));
                exit when CS(0) = '1';
                rx_word(i) := MOSI;
            end loop;

            -- 2. Анализируем, что от нас хочет ПЛИС:
            if CS(0) = '0' then
                -- Если просят ID (0x4F):
                if rx_word(23 downto 16) = X"4F" then
                    tx_word := X"005000";
                    
                -- Если просят данные замера (0x44):
                elsif rx_word(23 downto 16) = X"44" then
                    -- Чередуем тестовые данные для каждого следующего замера:
                    if chan_id = 0 then
                        tx_word := X"000300"; -- Первое число!
                        chan_id := 1;
                    else
                        tx_word := X"000FF0"; -- ВТОРОЕ ЧИСЛО!
                        chan_id := 0;
                    end if;
                else
                    tx_word := (others => '0');
                end if;

                -- 3. Выталкиваем оставшиеся 16 бит ответа по спаду SCLK:
                for i in 15 downto 0 loop
                    wait until falling_edge(SCLK) or rising_edge(CS(0));
                    exit when CS(0) = '1';
                    MISO(0) <= tx_word(i);
                end loop;
            end if;
        end loop;

        MISO(0) <= 'Z';
    end process VIRTUAL_ADC_1;