select batch_no, inventory_name
from batch
         join inventory on batch.inventory_id = inventory.id;