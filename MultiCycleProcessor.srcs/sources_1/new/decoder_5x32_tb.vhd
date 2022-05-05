---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/11/2022 02:49:28 PM
-- Module Name: Decoder 5x32 Module Testbench
-- Project Name: SingleCycleProcessor
-- Revision 1.00 - File Created and Quality control performed
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_5x32_tb is
end decoder_5x32_tb;

architecture Behavioral of decoder_5x32_tb is

    component decoder_5x32 is
        Port (
            input: in std_logic_vector(4 downto 0);
            output: out std_logic_vector(31 downto 0)   
        );
    end component;
    
signal input: std_logic_vector(4 downto 0);
signal output: std_logic_vector(31 downto 0); 

begin
    
    uut: decoder_5x32
    PORT MAP(
        input => input,
        output => output        
    );
    
    simProcess: process begin
    
        input <= "00001";
        wait for 100ns;
        
        input <= "11001";
        wait for 100ns;
        
        input <= "11111";
        wait for 100ns;
        
        input <= "10001";
        wait for 100ns;
        
        input <= "01001";
        wait for 100ns;
        
        input <= "00000";
        wait for 100ns;
        
        wait;
        
    end process;
    
end Behavioral;
