library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity acumulador is
    port(
        atualizar : in std_logic;
        entrada : in unsigned(15 downto 0);
        saida : out unsigned(15 downto 0)
    );
end entity;


architecture a_acumulador of acumulador is
    signal saida_signal : unsigned(15 downto 0);
    signal registro : unsigned(15 downto 0);

    begin

        saida_signal <= entrada when atualizar = '1' else registro;
        registro <= saida_signal;

        saida <= saida_signal;
end architecture;