library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- selectoption - seleciona a operação a ser feita, que são
-- 0 - soma
-- 1 - subtracao
-- 10 - a maior que b
-- 11 - a igual a b

-- variáveis de saída :
-- carry - informa se a soma excedeu a capacidade de representação
-- overflow - informa se a subtrção tbm escedeu
-- biggest - informa se a > b
-- egual - informa se a = b
-- result - resultado de soma/subtração

-- testes interessantes :
-- estourar a capacidade de representação em soma e subtraçao
-- comparar valores

entity ULA is
    port (
        ina : in unsigned(15 downto 0);
        inb : in unsigned(15 downto 0);
        operationselect : in unsigned(1 downto 0);
        carry : out std_logic;
        overflow : out std_logic;
        biggest : out std_logic;
        equal : out std_logic;
        result : out unsigned(15 downto 0)
    );
end entity;

architecture a_ULA of ULA is
    signal sub : unsigned(15 downto 0);
    signal soma : unsigned(15 downto 0);

    begin

        soma <= ina + inb;

        sub <= ina - inb;

        result <=   soma when operationselect = "00" else
                    sub when operationselect = "01" else
                    "0000000000000000";

        carry <=    '1' when operationselect = "00" and ( ina(15) = '0' and inb(15) = '0' and soma(15) = '1') else
                    '0';

        overflow <= '1' when operationselect = "01" and ( ina(15) = '1' and inb(15) = '0' and sub(15) = '0') else
                    '0';

        biggest <=  '0' when operationselect = "10" and ina(15) = '1' and inb(15) = '0' else
                    '1' when operationselect = "10" and ina > inb else
                    '0';

        equal <=    '1' when operationselect = "11" and ina = inb else
                    '0';

    end architecture;
