library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity testesoma_ULA_tb is
    end;

    architecture a_testesoma_ULA_tb of testesoma_ULA_tb is
        component ULA
        port(   ina : in unsigned(15 downto 0);
                inb : in unsigned(15 downto 0);
                operationselect : in unsigned(1 downto 0);
                carry : out std_logic;
                overflow : out std_logic;
                biggest : out std_logic;
                equal : out std_logic;
                result : out unsigned(15 downto 0)
        );
        end component;

        signal ina,inb,result : unsigned(15 downto 0);
        signal operationselect : unsigned(1 downto 0);
        signal carry,overflow,biggest,equal : std_logic;

        begin 
            uut : ULA port map(
                ina => ina,
                inb => inb,
                operationselect => operationselect,
                carry => carry,
                result => result
            );
        process
        begin
            wait for 50 ns;
            -- soma menor que a capacidade de representacao
            ina <= "0110000101110101";
            inb <= "0001101101010010";
            operationselect <= "00";

            wait for 50 ns;
            -- soma que não extoura o valor
            ina <= "0000110101001100";
            inb <= "0001000100111010";

            wait for 50 ns;
            -- soma que estoura a capacidade
            ina <= "0010000100110001";
            inb <= "0110110101001100";

            wait for 50 ns;
            -- soma diferente que também extoura
            ina <= "0100010100110001";
            inb <= "0100100101001110";
            
            wait for 50 ns;
            wait;
            
        end process;
    end architecture;