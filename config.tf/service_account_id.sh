#!/bin/bash

SERVICE_ACCOUNT_ID="ajejhtfl4ll3t1kmqgtj"
FOLDER_ID="b1gt6sro0sp7kjv4dnh1"

# Основные роли для работы Kubernetes
yc resource-manager folder add-access-binding $FOLDER_ID \
  --role editor \
  --service-account-id $SERVICE_ACCOUNT_ID

# Специфичные роли для Kubernetes
yc resource-manager folder add-access-binding $FOLDER_ID \
  --role k8s.clusters.agent \
  --service-account-id $SERVICE_ACCOUNT_ID

yc resource-manager folder add-access-binding $FOLDER_ID \
  --role vpc.publicAdmin \
  --service-account-id $SERVICE_ACCOUNT_ID

# Для работы с KMS (если используется шифрование)
yc resource-manager folder add-access-binding $FOLDER_ID \
  --role kms.keys.encrypterDecrypter \
  --service-account-id $SERVICE_ACCOUNT_ID

# Дополнительные роли (которые у вас уже были)
yc resource-manager folder add-access-binding $FOLDER_ID \
  --role storage.admin \
  --service-account-id $SERVICE_ACCOUNT_ID

yc resource-manager folder add-access-binding $FOLDER_ID \
  --role compute.editor \
  --service-account-id $SERVICE_ACCOUNT_ID

echo "Права для сервисного аккаунта $SERVICE_ACCOUNT_ID успешно назначены"
