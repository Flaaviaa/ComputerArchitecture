library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mutex1bit2vias is
    port(
        controle : in unsigned(1 downto 0) := "00";
        entradazero : in std_logic := '0';
        entradaum : in std_logic := '0';
        entradadois : in std_logic := '0';
        saida : out std_logic := '0'
    );
end entity;

architecture a_mutex1bit2vias of mutex1bit2vias is

    signal saida_signal : std_logic := '0';

    begin
    saida_signal <= entradaum when controle = "01" else
                    entradadois when controle = "10" else entradazero; 

    saida <= saida_signal;

end architecture;