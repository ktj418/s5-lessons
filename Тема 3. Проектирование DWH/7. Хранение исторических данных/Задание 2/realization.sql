-- Удалите внешний ключ из sales
--ALTER TABLE sales
--drop foreign key IF EXISTS;

-- Удалите первичный ключ из products
ALTER TABLE products
DROP CONSTRAINT products_pk CASCADE;


-- Добавьте новое поле id для суррогантного ключа в products
ALTER TABLE products
ADD id serial;

-- Сделайте данное поле первичным ключом
ALTER TABLE products
ADD CONSTRAINT pkey PRIMARY KEY (id);

-- Добавьте дату начала действия записи в products
ALTER TABLE products
ADD valid_from timestamptz;

-- Добавьте дату окончания действия записи в products
ALTER TABLE products
ADD valid_to timestamptz;

-- Добавьте новый внешний ключ sales_products_id_fk в sales
ALTER TABLE sales
ADD CONSTRAINT sales_products_id_fk 
FOREIGN KEY (product_id)
REFERENCES products(id);