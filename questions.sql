1  Listar os empregados (nomes) que tem salário maior que seu chefe (usar o join)

select emp.nome as Empregado 
from empregados emp
join empregados sup on emp.supervisor_id = sup.emp_id
where sup.salario < emp.salario

--  empregado | 
-- -----------+
--  Maria     |
--  Claudia   |
--  Ana       |
--  Luiz      |


2 Listar o maior salario de cada departamento (usa o group by )

select emp.dep_id, max(emp.salario) 
from empregados emp
group by emp.dep_id

--  dep_id |  max  
-- --------+-------
--       1 | 10000
--       2 |  8000
--       3 |  6000
--       4 | 12200



3 Listar o dep_id, nome e o salario do funcionario com maior salario dentro de cada departamento (usar o with)

with max_salario as (
    select emp.dep_id, max(emp.salario) as salario
    from empregados emp
    group by emp.dep_id
)

select  ms.dep_id, ms.salario, emp.nome
from max_salario ms
join empregados emp ON ms.dep_id = emp.dep_id AND ms.salario = emp.salario

--  dep_id |  nome   | salario 
-- --------+---------+---------
--       3 | Joao    |    6000
--       1 | Claudia |   10000
--       4 | Ana     |   12200
--       2 | Luiz    |    8000


4 Listar os nomes departamentos que tem menos de 3 empregados;

with quantidade_empregado_departamento as (
	select emp.dep_id, count(emp.emp_id) as quantidade
	from empregados emp
	group by emp.dep_id
)

select dep.nome, qed.quantidade
from quantidade_empregado_departamento as qed
natural join departamentos dep
where qed.quantidade < 3

--    nome    
-- -----------
--  Marketing
--  RH
--  Vendas


5 Listar os departamentos  com o número de colaboradores

with quantidade_empregado_departamento as (
	select emp.dep_id, count(emp.emp_id) as quantidade
	from empregados emp
	group by emp.dep_id
)

select dep.nome, qed.quantidade
from quantidade_empregado_departamento as qed
natural join departamentos dep

    
--    nome    | count 
-- -----------+-------
--  Marketing |     1
--  RH        |     2
--  TI        |     4
--  Vendas    |     1


6 Listar os empregados que não possue o seu  chefe no mesmo departamento/ 

select sup.nome, sup.dep_id 
from empregados emp
join empregados sup on emp.emp_id = sup.supervisor_id
where emp.dep_id != sup.dep_id


--  nome | dep_id 
-- ------+--------
--  Joao |      3
--  Ana  |      4


7 Listar os nomes dos  departamentos com o total de salários pagos (sliding windows function)

select dep.nome,
  (select sum(emp.salario) from empregados emp where emp.dep_id = dep.dep_id) as total_salario
from departamentos as dep;

--   sum  |   nome    
-- -------+-----------
--   6000 | Vendas
--  12200 | Marketing
--  15500 | RH
--  32500 | TI



8 Listar os nomes dos colaboradores com salario maior que a média do seu departamento (dica: usar subconsultas);

select emp.nome, emp.salario
from empregados as emp
join departamentos as dep on emp.dep_id = dep.dep_id
where emp.salario > (select avg(salario) from empregados where dep_id = emp.dep_id);

--   Nome   | Salário 
-- ---------+---------
--  Maria   |    9500
--  Claudia |   10000
--  Luiz    |    8000

 9  Faça uma consulta capaz de listar os dep_id, nome, salario, e as médias de cada departamento utilizando o windows function;

select emp.dep_id, emp.nome, emp.salario,
  round((select avg(salario) from empregados where dep_id = emp.dep_id), 0 )
from empregados emp
join departamentos dep on emp.dep_id = dep.dep_id

--  dep_id |   nome    | salario |  avg  
-- --------+-----------+---------+-------
--       1 | Jose      |    8000 |  8125
--       1 | Claudia   |   10000 |  8125
--       1 | Guilherme |    5000 |  8125
--       1 | Maria     |    9500 |  8125
--       2 | Luiz      |    8000 |  7750
--       2 | Pedro     |    7500 |  7750
--       3 | Joao      |    6000 |  6000
--       4 | Ana       |   12200 | 12200




10 - Encontre os empregados com salario maior ou igual a média do seu departamento. Deve ser reportado o salario do empregado e a média do departamento (dica: usar window function com subconsulta)

select emp.nome, emp.salario,
  (select avg(salario) from empregados where dep_id = emp.dep_id) as avg_salary
from empregados emp
where emp.salario >= (select avg(salario) from empregados where dep_id = emp.dep_id)

--   nome   | salario | dep_id |       avg_salary       
-- ---------+---------+--------+------------------------
--  Claudia |   10000 |      1 |  8125.0000000000000000
--  Maria   |    9500 |      1 |  8125.0000000000000000
--  Luiz    |    8000 |      2 |  7750.0000000000000000
--  Joao    |    6000 |      3 |  6000.0000000000000000
--  Ana     |   12200 |      4 | 12200.0000000000000000

