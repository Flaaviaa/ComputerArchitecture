library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity constante is
    port(
        instrucao : in unsigned(15 downto 0) := "0000000000000000";
        delta_salto_branch : out unsigned(6 downto 0) := "0000000";
        constante_saida : out unsigned(15 downto 0) := "0000000000000000"
    );
end entity;

architecture a_constate of constante is
    signal constante_saida_signal : unsigned(15 downto 0) := "0000000000000000";
    signal delta_salto_branch_signal : unsigned(6 downto 0) := "0000000";

    begin
        constante_saida_signal <= "00000000" & instrucao(7 downto 0);
        delta_salto_branch_signal <= instrucao(6 downto 0);

        delta_salto_branch <= delta_salto_branch_signal;
        constante_saida <= constante_saida_signal;
    end architecture;
