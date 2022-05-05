---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/11/2022 02:49:28 PM
-- Module Name: Register File - Behavioral Top Module
-- Project Name: SingleCycleProcessor
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.buses.ALL;

entity rf is
    Port (
        -- Entity inputs
        Ard1: in std_logic_vector(4 downto 0);
        Ard2: in std_logic_vector(4 downto 0);
        Awr: in std_logic_vector(4 downto 0);
        
        Din: in std_logic_vector(31 downto 0);
        WrEn: in std_logic;
        CLK: in std_logic;
        RST: in std_logic;
        
        --Entity Outputs
        Dout1: out std_logic_vector(31 downto 0);
        Dout2: out std_logic_vector(31 downto 0) 
    );
end rf;

architecture Behavioral of rf is
    
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
    
    component mux_32x1 is
        Port (
            input: in bus32x32;
            control: in std_logic_vector(4 downto 0);
            output: out std_logic_vector(31 downto 0)  
        );
    end component;
    
    component decoder_5x32 is
        Port (
            input: in std_logic_vector(4 downto 0);
            output: out std_logic_vector(31 downto 0)   
        );
    end component;
    
signal WE,DEC_OUT: std_logic_vector(31 downto 0);
signal BUS32: bus32x32;

begin
    
    decoder:
        decoder_5x32 PORT MAP(
            input => Awr,
            output => DEC_OUT
        );
    
    -- We need to generate the 32 AND gates for the WrEn 
    enablers:
        for j in 1 to 31 generate
            WE(j) <= (WrEn AND DEC_OUT(j));
        end generate enablers;
        
        WE(0) <= '0';
        
    -- Generating the register file using for-generate
    registers:
        for i in 0 to 31 generate
            RX: register_32 PORT MAP(
                CLK => CLK,
                RST => RST,
                WE => WE(i),
                Datain => Din,
                Dataout => BUS32(i)
            );
        end generate registers;
            
    mux1:
        mux_32x1 PORT MAP(
            input => BUS32,
            control => Ard1,
            output => Dout1
        );
           
    
    mux2:
        mux_32x1 PORT MAP(
            input => BUS32,
            control => Ard2,
            output => Dout2
        );   


end Behavioral;
