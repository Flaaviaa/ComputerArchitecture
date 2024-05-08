library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_tb is
    port(
        clk : in std_logic
    );
end entity;

architecture a_PC_tb of PC_tb is 
    signal registrador : unsigned(15 downto 0) := "0000000000000000";
    signal intervalo_tempo : time := 10 us;
    signal stoploop : std_logic := '0';

    component PC_tb is
    port(
        clk : in std_logic
    );
    end component;

    component somaum is
        port(
            entrada : in unsigned(15 downto 0);
            saida_maisum : out unsigned(15 downto 0)
        );
    end component;

    uut : 
