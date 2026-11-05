-- В AD7708_DRIVER.vhd:
imp_DATA_ERR : process (CLK) is
begin
    if rising_edge(CLK) then
        if (RST = '0') then
            DATA_ERR_SIG <= '0';
        elsif (DATA_RDY_SIG = '1') then  -- Было DATA_RDY_SIG_Z!
            if (ADC_DAT_ACCUM(19 downto 4) = X"0000") or 
               (ADC_DAT_ACCUM(19 downto 4) = X"FFFF") then
                DATA_ERR_SIG <= '1';
            else
                DATA_ERR_SIG <= '0';
            end if;
        else
            DATA_ERR_SIG <= '0';
        end if;
    end if;
end process;