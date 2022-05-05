---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/11/2022 02:49:28 PM
-- Module Name: register_32 - Behavioral
-- Project Name: SingleCycleProcessor
-- Revision 1.00 - Register Testbench Completed and Quality control performed
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_32_tb is
end register_32_tb;

architecture Behavioral of register_32_tb is
    component register_32 is
        Port (
            --Component inputs
            CLK: in std_logic;
            RST: in std_logic;
            WE: in std_logic;
            Datain: in std_logic_vector(31 downto 0);
            --Component outputs
            Dataout: out std_logic_vector(31 downto 0) 
        );
    end component;
    
    -- Local Signals 
    signal CLK,RST,WE: std_logic;
    signal Datain,Dataout: std_logic_vector(31 downto 0);
    signal inner_termin: std_logic;

    begin
       
       uut: register_32 
       PORT MAP(
           CLK => CLK,
           RST => RST,
           WE => WE,
           Datain => Datain,
           Dataout => Dataout
       );
    
    --Process for generating clock signal 
    clkProcess: process begin
        --Vary the clock signal for low to high every 30ns 
        --Period = 100ns
        CLK <= '0';
        wait for 50ns;
        CLK <= '1';
        wait for 50ns;
        
        --The terminationg flag will be HIGH after a certain time 
        --The clock is generated for this amount of time 
        inner_termin<='1' after 2500ns;
        
        --Checking if we should terminate the clock generation
        if inner_termin ='1' then
            CLK<='0';  --Set clock signal to low 
            wait; --End the clock generation process
        end if;
    end process;
    
       
    simProcess: process begin
        
        -- No reset is given in input 
        -- Trying to write different data with WE low
        RST <= '0';
        WE <= '0';
        
        Datain <= x"084abf32";
        wait for 100ns;
        
        Datain <= x"0fffffff";
        wait for 100ns;
        
        
        -- Setting WE high and trying again
        WE <= '1';
        Datain <= x"0abcdef0";
        wait for 100ns;
        
        Datain <= x"0fffffff";
        wait for 100ns;
        
        
        -- Testing the reset with and without WE
        RST <= '1';      
        Datain <= x"0abcdef0";
        wait for 100ns;
        RST <= '0';
        
        WE <= '1';
        Datain <= x"0cccdef0";
        wait for 100ns;
        
        WE <= '0';
        RST <= '1';
        wait for 100ns;
       
        wait;
    end process;
       



end Behavioral;
