---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/14/2022 12:31:08 PM
-- Module Name: decstage - Behavioral
-- Project Name: SingleCycleProcessor
-- Revision 1.00 - Decode Stage Top Module implemented
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decstage is
    Port (
        -- Entity inputs
        Instr: in std_logic_vector(31 downto 0);
        RF_WrEn: in std_logic;
        ALU_out: in std_logic_vector(31 downto 0);
        MEM_out: in std_logic_vector(31 downto 0);
        RF_WrData_sel: in std_logic;
        RF_B_sel: in std_logic;
        ImmExt: in std_logic_vector(1 downto 0);
        CLK: in std_logic;
        RST: in std_logic;
        
        -- Entity outputs
        Immed: out std_logic_vector(31 downto 0);
        RF_A: out std_logic_vector(31 downto 0);
        RF_B: out std_logic_vector(31 downto 0)         
    );
end decstage;

architecture Behavioral of decstage is

    component mux_2x1 is
         Port(
            control: in std_logic;
            A: in std_logic_vector(31 downto 0);
            B: in std_logic_vector(31 downto 0);
            Output: out std_logic_vector(31 downto 0)
         );   
    end component mux_2x1;
    
    component mux_2x1_5b is 
         Port(
            control: in std_logic;
            A: in std_logic_vector(4 downto 0);
            B: in std_logic_vector(4 downto 0);
            Output: out std_logic_vector(4 downto 0)
         );   
    end component mux_2x1_5b;
    
    component rf is
        Port (
            -- Component inputs
            Ard1: in std_logic_vector(4 downto 0);
            Ard2: in std_logic_vector(4 downto 0);
            Awr: in std_logic_vector(4 downto 0);
            
            Din: in std_logic_vector(31 downto 0);
            WrEn: in std_logic;
            CLK: in std_logic;
            RST: in std_logic;
            
            --Component Outputs
            Dout1: out std_logic_vector(31 downto 0);
            Dout2: out std_logic_vector(31 downto 0) 
        );
    end component rf;
    
    component immed_converter is
        Port (
            ImmExt: in std_logic_vector(1 downto 0);
            Instr: in std_logic_vector(15 downto 0);
            ImmedOut: out std_logic_vector(31 downto 0)
        );
    end component immed_converter;   

    signal outMux1 : std_logic_vector(4 downto 0);
    signal outMux2 : std_logic_vector(31 downto 0);
    
begin
    
    mux32: mux_2x1 PORT MAP(
        control => RF_WrData_sel,
        A => MEM_out,
        B => ALU_out,
        Output => outMux2
    );
    
    mux5: mux_2x1_5b PORT MAP(
        control => RF_B_sel,
        A => Instr(15 downto 11),
        B => Instr(20 downto 16),
        Output => outMux1
    );
    
    conv: immed_converter PORT MAP(
        ImmExt => ImmExt,
        Instr => Instr(15 downto 0),
        ImmedOut => Immed
    );
    
    rfile: rf PORT MAP(
        Ard1 => Instr(25 downto 21),
        Ard2 => outMux1,
        Awr => Instr(20 downto 16),
        Din => outMux2,
        WrEn => RF_WrEn,
        CLK => CLK,
        RST => RST,
        Dout1 => RF_A,
        Dout2 => RF_B   
    );
    

end Behavioral;
