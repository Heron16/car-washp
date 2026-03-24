-- ============================================================
--  AquaWash - Script de criação do banco de dados
--  Importar no XAMPP via phpMyAdmin ou MySQL CLI
-- ============================================================

CREATE DATABASE IF NOT EXISTS `carwash`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `carwash`;

-- ------------------------------------------------------------
-- Tabela: user
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `user` (
  `id`        VARCHAR(36)  NOT NULL DEFAULT (UUID()),
  `name`      VARCHAR(255) NOT NULL,
  `email`     VARCHAR(255) NOT NULL,
  `password`  VARCHAR(255) NOT NULL,
  `cpf`       VARCHAR(14)  NOT NULL,
  `role`      ENUM('client','admin') NOT NULL DEFAULT 'client',
  `phone`     VARCHAR(20)  NULL,
  `createdAt` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_email_unique` (`email`),
  UNIQUE KEY `user_cpf_unique` (`cpf`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabela: service
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `service` (
  `id`           VARCHAR(36)    NOT NULL DEFAULT (UUID()),
  `name`         VARCHAR(255)   NOT NULL,
  `description`  TEXT           NOT NULL,
  `price`        DECIMAL(10,2)  NOT NULL,
  `duration`     INT            NOT NULL,
  `vehicleTypes` VARCHAR(255)   NOT NULL DEFAULT 'car',
  `active`       TINYINT(1)     NOT NULL DEFAULT 1,
  `createdAt`    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabela: vehicle
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `vehicle` (
  `id`        VARCHAR(36)  NOT NULL DEFAULT (UUID()),
  `userId`    VARCHAR(36)  NOT NULL,
  `brand`     VARCHAR(255) NOT NULL,
  `model`     VARCHAR(255) NOT NULL,
  `year`      INT          NOT NULL,
  `plate`     VARCHAR(10)  NOT NULL,
  `color`     VARCHAR(255) NOT NULL,
  `type`      ENUM('car','motorcycle','truck','suv') NOT NULL DEFAULT 'car',
  `createdAt` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vehicle_plate_unique` (`plate`),
  CONSTRAINT `fk_vehicle_user`
    FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabela: appointment
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `appointment` (
  `id`          VARCHAR(36)   NOT NULL DEFAULT (UUID()),
  `userId`      VARCHAR(36)   NOT NULL,
  `vehicleId`   VARCHAR(36)   NOT NULL,
  `serviceId`   VARCHAR(36)   NOT NULL,
  `scheduledAt` DATETIME      NOT NULL,
  `status`      ENUM('pending','in_progress','completed','cancelled') NOT NULL DEFAULT 'pending',
  `notes`       VARCHAR(255)  NULL,
  `totalPrice`  DECIMAL(10,2) NOT NULL,
  `createdAt`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_appointment_user`
    FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_appointment_vehicle`
    FOREIGN KEY (`vehicleId`) REFERENCES `vehicle` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_appointment_service`
    FOREIGN KEY (`serviceId`) REFERENCES `service` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Dados iniciais: serviços de exemplo
-- ------------------------------------------------------------
INSERT IGNORE INTO `service` (`id`, `name`, `description`, `price`, `duration`, `vehicleTypes`, `active`) VALUES
  (UUID(), 'Lavagem Simples',    'Lavagem externa completa com água e sabão',                          35.00,  30, 'car,motorcycle,suv',       1),
  (UUID(), 'Lavagem Completa',   'Lavagem interna e externa com aspiração e limpeza de vidros',        65.00,  60, 'car,suv,truck',             1),
  (UUID(), 'Polimento',          'Polimento completo da lataria com cera protetora',                  120.00,  90, 'car,suv',                   1),
  (UUID(), 'Higienização',       'Higienização completa do interior com produtos especializados',     150.00, 120, 'car,suv,truck',             1),
  (UUID(), 'Lavagem Moto',       'Lavagem completa para motocicletas',                                 25.00,  20, 'motorcycle',                1),
  (UUID(), 'Lavagem Caminhão',   'Lavagem externa para caminhões e veículos de grande porte',         100.00,  90, 'truck',                     1);
