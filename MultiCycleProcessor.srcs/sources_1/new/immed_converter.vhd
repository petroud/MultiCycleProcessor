---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/14/2022 12:31:08 PM
-- Module Name: immed_converter - Behavioral
-- Project Name: SingleCycleProcessor
-- Revision 1.00 - Immediate Converter to 32bits - "The Cloud"
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity immed_converter is
    Port (
        ImmExt: in std_logic_vector(1 downto 0);
        Instr: in std_logic_vector(15 downto 0);
        ImmedOut: out std_logic_vector(31 downto 0)
    );
end immed_converter;

-- The logic of the converter is 
-- 00: Zero fill
-- 01: Sign extend
-- 10: Sign extend + Shift left by 2 bits
-- 11: Shift left 16 bits and 16 bits ZF
architecture Behavioral of immed_converter is


begin
    
    ImmedOut(31 downto 16) <=                             x"0000" when ImmExt = "00" else
                                            (others => Instr(15)) when ImmExt = "01" else
                            (16 => Instr(14), others=> Instr(15)) when ImmExt = "10" else 
                                               Instr(15 downto 0) when ImmExt = "11";
                                               
    ImmedOut(15 downto 0)  <=                               Instr when ImmExt = "00" else
                                                            Instr when ImmExt = "01" else
                (std_logic_vector(shift_left(unsigned(Instr),2))) when ImmExt = "10" else
                                                          x"0000" when ImmExt = "11";


end Behavioral;
