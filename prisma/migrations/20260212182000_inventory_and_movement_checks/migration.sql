ALTER TABLE "inventory_items"
DROP COLUMN IF EXISTS "availableQuantity";

ALTER TABLE "inventory_items"
ADD CONSTRAINT "inventory_items_reserved_lte_quantity_check"
CHECK ("reservedQuantity" <= "quantity");

ALTER TABLE "movement_records"
ADD CONSTRAINT "movement_records_quantity_sign_check"
CHECK (
  (
    "type" IN ('PURCHASE'::"MovementType", 'TRANSFER_IN'::"MovementType")
    AND "quantity" > 0
  )
  OR (
    "type" IN (
      'SALE'::"MovementType",
      'TRANSFER_OUT'::"MovementType",
      'DAMAGED'::"MovementType",
      'LOST'::"MovementType"
    )
    AND "quantity" < 0
  )
  OR (
    "type" IN ('ADJUSTMENT'::"MovementType", 'RETURN'::"MovementType")
    AND "quantity" <> 0
  )
);

ALTER TABLE "movement_records"
ADD CONSTRAINT "movement_records_location_combo_check"
CHECK (
  "locationId" IS NOT NULL
  AND (
    ("type" = 'TRANSFER_OUT'::"MovementType" AND "fromLocationId" IS NOT NULL)
    OR ("type" <> 'TRANSFER_OUT'::"MovementType" AND "fromLocationId" IS NULL)
  )
);
