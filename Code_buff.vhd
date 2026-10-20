ADC_MOSI <= X"010300"               when FIRST_START = '1'      -- 1. Пробудить АЦП
       else X"0F0000"               when DEV_CHANGED = '1'      -- 2. Сменился чип -> опрос ID
       else X"440000"               when FIRST_DATA = '0'       -- 3. Обычный замер (чтение)
       else X"02" & CHAN_SIG & X"700";                          -- 4. Смена канала из LUT