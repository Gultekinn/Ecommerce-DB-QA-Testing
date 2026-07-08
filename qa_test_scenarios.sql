-- müsahibələrdə "Bizim e-ticarət bazamızda bu problemi necə yoxlayarsan?" deyə qarşına çıxacaq qızıl ssenarilərdir.
  -- Ssenari 1: Sifarişi olan amma heç bir ödəniş qeydi olmayan userləri tap (Kritik Xəta!)
  SELECT order_id, user_id, status 
FROM orders 
WHERE order_id NOT IN (SELECT order_id FROM payments);
-- Ssenari 2: Eyni email-dən duplicate qeydiyyat var mı?
SELECT name, email FROM users 
WHERE email IN (
    SELECT email FROM users 
    GROUP BY email 
    HAVING COUNT(*) > 1
);
-- Ssenari 3: Stock-da olmayan məhsulun sifarişi mövcuddur mu? (Biznes Məntiqi Xətası)
SELECT oi.order_id, p.product_name, p.stock, oi.quantity 
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
WHERE p.stock = 0;
-- 4. Son 30 gündə ən çox alan 5 müştəri kim? (Top Customers / Analytics Test)
SELECT u.name, SUM(p.amount) AS total_spent
FROM users u
INNER JOIN orders o ON u.user_id = o.user_id
INNER JOIN payments p ON o.order_id = p.order_id
WHERE o.status = 'completed' 
  AND o.order_date >= DATE_SUB('2026-07-07', INTERVAL 60 DAY)
GROUP BY u.user_id, u.name
ORDER BY total_spent DESC
LIMIT 5;
-- 5. Ləğv edilmiş sifarişlər üçün refund (geri ödəniş) qeydi yaradılıb mı?
SELECT o.order_id, o.status AS order_status, p.payment_status, p.amount
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE o.status = 'cancelled';