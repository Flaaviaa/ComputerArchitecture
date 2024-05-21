library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity calculadoraprogramavel_tb is
end entity;

architecture a_calculadoraprogramavel_tb of calculadoraprogramavel_tb is
    signal contador : unsigned(4 downto 0) := "00000";

    signal clock,reset : std_logic := '0';
    signal estado : unsigned(1 downto 0) := "00";
    signal instrucao : unsigned(15 downto 0) := "0000000000000000";
    signal saida_banco_reg1 : unsigned(15 downto 0) := "0000000000000000";
    signal saida_banco_reg2 : unsigned(15 downto 0) := "0000000000000000";
    signal saida_ula :  unsigned(15 downto 0) := "0000000000000000";

    component calculadoraprogramavel is
        port(
            rst : in std_logic;
            clk : in std_logic;
            estado : out unsigned(1 downto 0);
            instrucao : out unsigned(15 downto 0);
            saida_bancoregistradores_reg1 : out unsigned(15 downto 0);
            saida_bancoregistradores_reg2 : out unsigned(15 downto 0);
            saida_ula : out unsigned(15 downto 0)

        );
    end component;
    begin
        uut : calculadoraprogramavel port map(
            rst => reset,
            clk => clock,
            estado => estado,
            instrucao => instrucao,
            saida_bancoregistradores_reg1 => saida_banco_reg1,
            saida_bancoregistradores_reg2 => saida_banco_reg2,
            saida_ula => saida_ula
        );

        process
            begin 
                while contador /= "11111" loop
                    wait for 50 ns;
                    clock <= '0';
                    wait for 50 ns;
                    clock <= '1';
                    contador <= contador + 1;

                end loop;
                wait;
        end process;
end architecture;