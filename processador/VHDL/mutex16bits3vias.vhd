library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mutex16bits3vias is
    port(
        controle : in unsigned(1 downto 0):= "00";
        entradazero : in unsigned(15 downto 0) := "0000000000000000";
        entradaum : in unsigned(15 downto 0) := "0000000000000000";
        entradadois : in unsigned(15 downto 0) := "0000000000000000";
        saida : out unsigned(15 downto 0) := "0000000000000000"
    );
end entity;

architecture a_mutex16bits3vias of mutex16bits3vias is

    signal saida_signal : unsigned(15 downto 0) := "0000000000000000";

    begin
    saida_signal <= entradazero when controle = "00" else
                    entradaum when controle = "01" else
                    entradadois ; 

    saida <= saida_signal;

end architecture;