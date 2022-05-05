library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity rf_tb is
end rf_tb;

architecture Behavioral of rf_tb is
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
            
            -- Component Outputs
            Dout1: out std_logic_vector(31 downto 0);
            Dout2: out std_logic_vector(31 downto 0) 
          );
    end component;
    
signal Ard1,Ard2,Awr: std_logic_vector(4 downto 0);
signal Din,Dout1,Dout2: std_logic_vector(31 downto 0);
signal WrEn,CLK,RST,inner_termin: std_logic;

begin
    
    uut: rf 
    PORT MAP(
        Ard1=>Ard1,
        Ard2=>Ard2,
        Awr=>Awr,
        Din=>Din,
        WrEn=>WrEn,
        CLK=>CLK,
        RST=>RST,
        Dout1=>Dout1,
        Dout2=>Dout2
    );
    
    simprocess: process begin
        
        --Lets assume that RST is zero for now and that we are not able to write
        RST <= '0';
        WrEn <= '0';
        
        Din <= x"35d45ba6";
        Awr <= "00010"; --Try writing on register 2;
        wait for 100ns;        
        
        --Now we should be able to write something in R3
        
        WrEn<='1';
        Din <= x"35e45006";
        Awr <= "00011"; --Try writing on register 3;
        wait for 100ns;      
        
        Din <= x"ffffffff";
        Awr <= "01000"; --Try writing on register 8;
        wait for 100ns;
        
        
        -- Lets Read what we wrote before
        WrEn<='0';
        Ard1<="00011";
        Ard2<="01000";
        wait for 100ns;       
        
        
        -- Lets reset the registers
        RST<='1';   
        wait for 100ns;
        RST<='0';
        
        -- Lets try writing in R0
        WrEn<='1';
        Awr<="00000";
        Din<=x"ffffffff";
        wait for 100ns;
        
        WrEn<='0';
        Ard1<="00000";
        wait for 100ns;
        
        wait;
    end process;
    
    
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
        inner_termin<='1' after 3000ns;
        
        --Checking if we should terminate the clock generation
        if inner_termin ='1' then
            CLK<='0';  --Set clock signal to low 
            wait; --End the clock generation process
        end if;
    end process;


end Behavioral;
