library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC_tb is
end entity;

architecture a_UC_tb of UC_tb is
    signal clk,rst,wr_en,opcode_erro : std_logic := '1';
    signal contador : unsigned(6 downto 0) := "0000000";
    signal instrucao : unsigned(15 downto 0) := "0000000000000000";

    component UC is
        port(
            clk,rst,wr_en : in std_logic;
            opcode_erro : out std_logic;
            instrucao : out unsigned(15 downto 0)
        );
    end component;

    begin
    uut : UC port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        opcode_erro => opcode_erro,
        instrucao => instrucao
    );

    process
    begin
        rst <= '1';
        wait for 400 ns;
        rst <= '0';
        wait;
    end process;

    process
        begin
            while contador /= "1111111" loop
                wait for 50 ns;
                clk <= '1';
                wait for 50 ns;
                clk <= '0';
                contador <= contador + 1;
            end loop;
            wait;
    end process;
end architecture;

