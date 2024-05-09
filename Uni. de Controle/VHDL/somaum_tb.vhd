library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somaum_tb is
end;

architecture a_somaum_tb of somaum_tb is
    component somaum
    port(
        entrada : in unsigned(15 downto 0);
        saida : out unsigned(15 downto 0)
    );
    end component;
    signal entrada,saida : unsigned(15 downto 0);

    begin
        uut : somaum port map(
            entrada => entrada,
            saida => saida
        );
    process
    begin 
        wait for 50 ns;
        entrada <= "0000000000000000";
        wait for 50 ns;
        entrada <= "0000000000000001";
        wait for 50 ns;
        entrada <= "0000000000000010";
        wait for 50 ns;
        entrada <= "0000000000000011";
        wait for 50 ns;
        entrada <= "0000000000000100";
        wait for 50 ns;
        entrada <= "0000010001000001";
        wait for 50 ns;
        entrada <= "0000000001110011";
        wait for 50 ns;
        entrada <= "0111111111111111";
        wait;
    end process;

end architecture;
	