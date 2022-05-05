library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memstage_tb is
end memstage_tb;

architecture Behavioral of memstage_tb is

    component memstage is
        Port (
            -- Component inputs 
            ByteOp : in std_logic;
            Mem_WrEn : in std_logic;
            ALU_MEM_Addr: in std_logic_vector(31 downto 0);
            MEM_DataIn: in std_logic_vector(31 downto 0);
            MM_RdData: in std_logic_vector(31 downto 0);
    
            -- Component outputs
            MEM_DataOut: out std_logic_vector(31 downto 0);
            MM_WrEn: out std_logic;
            MM_Addr: out std_logic_vector(31 downto 0);
            MM_WrData: out std_logic_vector(31 downto 0)
        );
    end component;

signal ByteOp, Mem_WrEn, MM_WrEn: std_logic;
signal ALU_MEM_Addr, MEM_DataIn, MM_RdData, MEM_DataOut, MM_Addr, MM_WrData: std_logic_vector(31 downto 0);

begin
    
    uut: memstage PORT MAP(
        ByteOp => ByteOp,
        Mem_WrEn => Mem_WrEn,
        ALU_MEM_Addr => ALU_MEM_Addr,
        MEM_DataIn => MEM_DataIn,
        MM_RdData => MM_RdData,
        MEM_DataOut => MEM_DataOut,
        MM_WrEn => MM_WrEn,
        MM_Addr => MM_Addr,
        MM_WrData => MM_WrData
    );
    
    simProcess: process begin
    
        --lw
        ByteOp <= '0';
        Mem_WrEn <= '0';
        ALU_Mem_Addr <= x"00000004";
        MEM_DataIn <= x"00000000";
        MM_RdData <= x"0000abcd";
        wait for 100ns;
        
        --lb
        ByteOp <= '1';
        Mem_WrEn <= '0';
        ALU_Mem_Addr <= x"00000004";
        MEM_DataIn <= x"00000000";
        MM_RdData <= x"0000abcd";
        wait for 100ns;
    
        --sw
        ByteOp <= '0';
        Mem_WrEn <= '1';
        ALU_Mem_Addr <= x"00000004";
        MEM_DataIn <= x"0000abcd";
        MM_RdData <= x"00000000";
        wait for 100ns;
    
        --sb
        ByteOp <= '1';
        Mem_WrEn <= '1';
        ALU_Mem_Addr <= x"00000004";
        MEM_DataIn <= x"0000abcd";
        MM_RdData <= x"0000a000";
        wait for 100ns;
    
        wait;
    end process;


end Behavioral;
