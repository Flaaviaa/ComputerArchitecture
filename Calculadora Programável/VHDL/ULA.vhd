library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- selectoption - seleciona a operação a ser feita, que são
-- 00 - soma
-- 01 - subtracao
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
        ina : in unsigned(15 downto 0) := "0000000000000000";
        inb : in unsigned(15 downto 0) := "0000000000000000";
        operationselect : in unsigned(1 downto 0) := "00";
        zeraflag : in std_logic := '0';
        overflow : out std_logic := '0';
        biggest : out std_logic := '0';
        equal : out std_logic := '0';
        result : out unsigned(15 downto 0) := "0000000000000000"
    );
end entity;

architecture a_ULA of ULA is
    signal sub : unsigned(15 downto 0) := "0000000000000000";
    signal soma : unsigned(15 downto 0) := "0000000000000000";

    begin

        soma <= ina + inb;

        sub <= ina - inb;

        result <=   "0000000000000000" when zeraflag = '1' else
                    soma when operationselect = "00" else
                    sub when operationselect = "01" else
                    "0000000000000000";

        overflow <= '1' when operationselect = "01" and ( ina(15) = '1' and inb(15) = '0' and sub(15) = '0') else
                    '0';

        biggest <=  '0' when operationselect = "10" and ina(15) = '1' and inb(15) = '0' else
                    '1' when operationselect = "10" and ina > inb else
                    '0';

        equal <=    '1' when operationselect = "11" and ina = inb else
                    '0';

    end architecture;
