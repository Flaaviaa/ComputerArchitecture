library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_tb is
end;

architecture a_PC_tb of PC_tb is 
    signal registrador : unsigned(6 downto 0) := "0000000";
    signal stopcont : unsigned(6 downto  0) := "1000000";
    signal clk : std_logic;
    signal wr_en : std_logic;
    signal data_in : unsigned(6 downto 0);
    signal data_out : unsigned(6 downto 0);

    component PC is
    port(
        clk      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
    );
    end component;

    begin
    uut : PC port map(
        clk => clk,
        wr_en => wr_en,
        data_in => data_in,
        data_out => data_out
    );

    process
    begin
        while registrador /= stopcont loop
            wait for 50 ns;
            clk <= '1';
            wait for 50 ns;
            clk <= '0';
            if wr_en = '1' then
                data_in <= registrador;
                wr_en <= '0';
            else
                wr_en <= '1';
            end if;
            registrador <= registrador + "0000001";
            end loop;
            wait;
            end process;
    end architecture;
