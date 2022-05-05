---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/14/2022 12:31:08 PM
-- Module Name: immed_converter_tb - Behavioral
-- Project Name: SingleCycleProcessor
-- Revision 1.00 - Immediate Converter Testbench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity immed_converter_tb is
end immed_converter_tb;

architecture Behavioral of immed_converter_tb is

    component immed_converter is
         Port (
            ImmExt: in std_logic_vector(1 downto 0);
            Instr: in std_logic_vector(15 downto 0);
            ImmedOut: out std_logic_vector(31 downto 0)
         ); 
    end component immed_converter;


signal ImmExt : std_logic_vector(1 downto 0);
signal Instr : std_logic_vector(15 downto 0);
signal ImmedOut : std_logic_vector(31 downto 0);

 
begin
    uut: immed_converter PORT MAP(
        ImmExt => ImmExt,
        Instr => Instr,
        ImmedOut => ImmedOut
    );
    
    simProcess: process begin
        
        ImmExt <= "00";
        Instr <= "1010110001000101";
        wait for 100ns;
        
        ImmExt <= "01";
        wait for 100ns;
        
        ImmExt <= "10";
        wait for 100ns;
        
        ImmExt <= "11";
        wait for 100ns;
        
        wait;
    end process simProcess;



end Behavioral;
