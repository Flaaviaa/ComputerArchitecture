library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mutex16bits2vias is
    port(
        controle : in std_logic := '0';
        entradazero : in unsigned(15 downto 0) := "0000000000000000";
        entradaum : in unsigned(15 downto 0) := "0000000000000000";
        saida : out unsigned(15 downto 0)
    );
end entity;

architecture a_mutex16bits2vias of mutex16bits2vias is

    signal saida_signal : unsigned(15 downto 0) := "0000000000000000";

    begin
    saida_signal <= entradaum when controle = '1' else entradazero; 

    saida <= saida_signal;

end architecture;