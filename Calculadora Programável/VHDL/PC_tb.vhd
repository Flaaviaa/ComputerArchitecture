library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_tb is
end;

architecture a_PC_tb of PC_tb is 
    signal registrador : unsigned(6 downto 0) := "0000000";
    signal stopcont : unsigned(6 downto  0) := "1000000";
    signal clk : std_logic;
    signal rst : std_logic := '0';
    signal wr_en : std_logic := '1';
    signal saltar : std_logic := '0';
    signal data_in : unsigned(6 downto 0) := "0000000";
    signal data_out : unsigned(6 downto 0) := "0000000";

    component PC is
    port(
        rst      : in std_logic;
        clk      : in std_logic;
        wr_en    : in std_logic;
        saltar   : in std_logic;
        endereco_entrada  : in unsigned(6 downto 0);
        endereco_saida : out unsigned(6 downto 0)
    );
    end component;

    begin
    uut : PC port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        saltar => saltar,
        endereco_entrada => data_in,
        endereco_saida => data_out
    );

    data_in <= registrador;

    process 
    begin
        
        wait for 400 ns;
        saltar <= '0';
        wait for 400 ns;
        saltar <= '1';
        wait for 400 ns;
        saltar <= '0';
        wait;

    end process;

    process
    begin
        while registrador /= stopcont loop
            wait for 50 ns;
            clk <= '1';
            wait for 50 ns;
            clk <= '0';
            registrador <= registrador + "0000010";
            end loop;
            wait;
            end process;
    end architecture;
