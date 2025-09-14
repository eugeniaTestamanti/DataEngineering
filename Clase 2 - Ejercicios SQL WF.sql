/*1. Obtener el promedio de precios por cada categoría de producto. La cláusula 
OVER(PARTITION BY CategoryID) específica que se debe calcular el promedio de 
precios por cada valor único de CategoryID en la tabla.*/
select c.category_name, p.product_name, p.unit_price, 
AVG(p.unit_price) over (partition by p.category_id) as "PromedioDePrecios" from
products p
inner join categories c on p.category_id = c.category_id

/*2. Obtener el promedio de venta de cada cliente*/
select avg(od.unit_price *od.quantity) over(partition by c.customer_id) as avgorderamount, o.order_id, c.customer_id, o.employee_id, o.order_date, o.required_date, o.shipped_date
from order_details od 
left join orders o on od.order_id = o.order_id 
left join customers c on o.customer_id = c.customer_id

/*3. Obtener el promedio de cantidad de productos vendidos por categoría (product_name, 
quantity_per_unit, unit_price, quantity, avgquantity) y ordenarlo por nombre de la 
categoría y nombre del producto */
select p.product_name, c.category_name, p.quantity_per_unit, od.unit_price, od.quantity, 
AVG(od.quantity) over (partition by p.category_id) as avgquantity
from products p
inner join categories c on p.category_id = c.category_id 
inner join order_Details od on p.product_id  = od.product_id 
order by c.category_name, p.product_name

/*4. Selecciona el ID del cliente, la fecha de la orden y la fecha más antigua de la 
orden para cada cliente de la tabla 'Orders'.  */
select o.customer_id, o.order_date, MIN(o.order_date) over (partition by customer_id) as PrimerOrden
from orders o 

/*5. Seleccione el id de producto, el nombre de producto, el precio unitario, el id de 
categoría y el precio unitario máximo para cada categoría de la tabla Products.*/
select product_id, product_name, unit_price, category_id, MAX(unit_price) over (partition by category_id) as PrecioMaxUnitario
from products

/*6.Obtener el ranking de los productos más vendidos */
select row_number() over (order by sum(od.quantity) desc) as ranking,
p.product_name,
sum(od.quantity) as totalquantity
from order_details od
inner join products p on od.product_id = p.product_id
group by p.product_name;

/*7.Asignar numeros de fila para cada cliente, ordenados por customer_id*/
select row_number() over (order by customer_id), *
from customers

/*8.Obtener el ranking de los empleados más jóvenes () ranking, nombre y apellido del 
empleado, fecha de nacimiento)*/
select row_number() over (order by birth_date desc) as ranking, concat(first_name,last_name) as employeename, birth_date
from employees

/*9.Obtener la suma de venta de cada cliente*/
select SUM(unit_price*quantity) over (partition by c.customer_id) as sumorderamount, 
o.order_id, c.customer_id, employee_id, order_date, required_date
from order_details od
inner join orders o on od.order_id = o.order_id 
inner join customers c on o.customer_id = c.customer_id 

/*10. Obtener la suma total de ventas por categoría de producto*/
select distinct c.category_name, p.product_name, od.unit_price, od.quantity,
sum(od.quantity * od.unit_price) over (partition by p.category_id) as totalsales
from order_details od
inner join products p on od.product_id = p.product_id
inner join categories c on p.category_id = c.category_id
order by totalsales desc

/*11. Calcular la suma total de gastos de envío por país de destino, luego ordenarlo por país 
y por orden de manera ascendente */
SELECT ship_country,
order_id, 
shipped_date,
freight,
SUM(freight) over (partition by ship_country) as totalshippingcosts
FROM public.orders
order by ship_country, order_id asc

/*12. Ranking de ventas por cliente */
select 
    a.customer_id,
    a.company_name,
    a.totalsales,
    rank() over (order by a.totalsales desc) as rank
from (
    select distinct 
        o.customer_id,
        c.company_name,
        sum(od.unit_price * od.quantity) over (partition by c.customer_id) as totalsales
    from public.orders o
    left join order_details od on o.order_id = od.order_id 
    left join customers c on o.customer_id = c.customer_id
) a

/*13. Ranking de empleados por fecha de contratacion*/
select employee_id, first_name, last_name, hire_date,
rank() over (order by hire_date)
from public.employees

/*14. Ranking de productos por precio unitario */
select product_id, product_name, unit_price, rank() over (order by unit_price desc)
from products 

/*15. Mostrar por cada producto de una orden, la cantidad vendida y la cantidad 
vendida del producto previo. */ 
select order_id, product_id, quantity as cantidadVendida,
lag(quantity) over (order by order_id) cantidadVendidaPrevia
from order_details

/*16. Obtener un listado de ordenes mostrando el id de la orden, fecha de orden, id del cliente 
y última fecha de orden.*/
select order_id, order_date, customer_id, 
lag(order_date) over (partition by customer_id order by order_date) as lastorderdate
from public.orders

/*17. Obtener un listado de productos que contengan: id de producto, nombre del producto, 
precio unitario, precio del producto anterior, diferencia entre el precio del producto y 
precio del producto anterior. */
select product_id, product_name, unit_price, 
lag(unit_price) over (order by product_id) as precioAnterior,
(lag(unit_price) over (order by product_id) - unit_price ) as diferencia
from public.products

/*18. Obtener un listado que muestra el precio de un producto junto con el precio del producto 
siguiente:*/
select product_name, unit_price,
lead(unit_price) over (order by product_id)
from public.products

/*19. Obtener un listado que muestra el total de ventas por categoría de producto junto con el 
total de ventas de la categoría siguiente */
select a.category_name, a.totalVentas, lead(a.totalVentas) over (order by a.category_name)
from(
select distinct c.category_name,
sum(od.unit_price*od.quantity) over (partition by c.category_name) as totalVentas
from public.products p
inner join categories c on p.category_id = c.category_id 
inner join order_details od on p.product_id = od.product_id
) a
