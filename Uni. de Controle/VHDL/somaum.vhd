library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somaum is
    port ( 
        entrada : in unsigned(15 downto 0);
        saida_maisum : out unsigned(15 downto 0)
    );
end entity;

architecture a_somaum of somaum is
    begin
        saida_maisum <= entrada + "0000000000000001";
end architecture;
	