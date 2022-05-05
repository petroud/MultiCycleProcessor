library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity exstage is
    Port (
        RF_A : in std_logic_vector(31 downto 0);
        RF_B : in std_logic_vector(31 downto 0);
        Immed: in std_logic_vector(31 downto 0);
        ALU_Bin_sel: in std_logic;
        ALU_func: in std_logic_vector(3 downto 0);
        ALU_out: out std_logic_vector(31 downto 0);
        ALU_zero: out std_logic;
        ALU_ovf: out std_logic
    );
end exstage;

architecture Behavioral of exstage is

    component ALU is
         Port (
             --Component inputs
             A: in std_logic_vector(31 downto 0);
             B: in std_logic_vector(31 downto 0);
             Op: in std_logic_vector(3 downto 0);
             --Component outputs
             Output: out std_logic_vector(31 downto 0);
             Zero: out std_logic;
             Cout: out std_logic;
             Ovf: out std_logic
         );
    end component ALU;
    
    component mux_2x1 is
        Port(
            control: in std_logic;
            A: in std_logic_vector(31 downto 0);
            B: in std_logic_vector(31 downto 0);
            Output: out std_logic_vector(31 downto 0)
        );   
    end component mux_2x1;

signal muxOutput : std_logic_vector(31 downto 0);

begin

    
    mux0: mux_2x1 PORT MAP(
        control => ALU_Bin_sel,
        A => RF_B,
        B => Immed,
        Output => muxOutput
    );
    
    alu0: alu PORT MAP(
        A => RF_A,
        B => muxOutput,
        Op => ALU_func,
        Output => ALU_out,
        Zero => ALU_zero,
        Cout => open,
        Ovf => ALU_ovf
    );
    


end Behavioral;
