library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mutex16bits2vias_tb is
end entity;

architecture a_mutex16bits2vias_tb of mutex16bits2vias_tb is
    -- variaveis
    signal entradazero,entradaum : unsigned(15 downto 0) := "0000000000000000";
    signal controle : std_logic := '0';
    signal saida : unsigned(15 downto 0);

    signal contador : unsigned(3 downto 0) := "0000";

    component mutex16bits2vias is
        port(
            controle : in std_logic;
            entradazero : in unsigned(15 downto 0);
            entradaum : in unsigned(15 downto 0);
            saida : out unsigned(15 downto 0)
        );
    end component;

    begin
        uut : mutex16bits2vias port map(
            controle => controle,
            entradazero => entradazero,
            entradaum => entradaum,
            saida => saida
        );

    
    process
        begin 
        while contador /= "1111" loop
            controle <= not controle;
            wait for 50 ns;
            entradazero <= entradazero + 4;
            entradaum <= entradaum + 1;
            contador <= contador + 1;
            end loop;
            wait;
    end process;

end architecture;