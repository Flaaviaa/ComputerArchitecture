library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity acumulador is
    port(
        atualizar : in std_logic := '0';
        entrada : in unsigned(15 downto 0) := "0000000000000000";
        saida : out unsigned(15 downto 0) := "0000000000000000"
    );
end entity;


architecture a_acumulador of acumulador is
    signal saida_signal : unsigned(15 downto 0) := "0000000000000000";
    signal registro : unsigned(15 downto 0) := "0000000000000000";

    begin

        saida_signal <= entrada when atualizar = '1' else registro;
        registro <= saida_signal;

        saida <= saida_signal;
end architecture;