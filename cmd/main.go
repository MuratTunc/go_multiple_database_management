package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
	_ "github.com/lib/pq"
	_ "github.com/mattn/go-sqlite3"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

type DatabaseConfig struct {
	Name     string
	Host     string
	Port     int
	User     string
	Password string
}

func ConnectToPostgreSQL(config DatabaseConfig) (*sql.DB, error) {
	connStr := fmt.Sprintf("user=%s password=%s dbname=%s host=%s port=%d sslmode=disable",
		config.User, config.Password, config.Name, config.Host, config.Port)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil, err
	}
	return db, nil
}

func ConnectToMySQL(config DatabaseConfig) (*sql.DB, error) {
	connStr := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s", config.User, config.Password, config.Host, config.Port, config.Name)
	db, err := sql.Open("mysql", connStr)
	if err != nil {
		return nil, err
	}
	return db, nil
}

func ConnectToSQLite(config DatabaseConfig) (*sql.DB, error) {
	db, err := sql.Open("sqlite3", config.Name)
	if err != nil {
		return nil, err
	}
	return db, nil
}

// ConnectMongoDb take mongodb url and related to connections
func ConnectMongoDb(config DatabaseConfig) (*mongo.Client, error) {

	var ctx = context.TODO()
	clientOptions := options.Client().ApplyURI("mongodb://localhost:27017/")
	client, err := mongo.Connect(ctx, clientOptions)
	if err != nil {
		log.Fatal(err)
	}

	err = client.Ping(ctx, nil)
	if err != nil {
		log.Fatal(err)
	}

	defer func() {
		if err := client.Disconnect(context.TODO()); err != nil {
			panic(err)
		}
	}()

	return client, nil
}

// ConnectMongoDb take mongodb url and related to connections
func ConnectToMaria(config MariaConfig) (maria.DB, error) {

	dsn := "root:changeme@tcp(127.0.0.1:3306)/golang_101?charset=utf8mb4&parseTime=True&loc=Local"
	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("open db error: %v", err)
	}
	// Get the underlying sql.DB object to close the connection later
	sqlDB, err := db.DB()
	if err != nil {
		log.Printf("get db error: %v", err)
		return sqlDB, err
	}
	defer sqlDB.Close()
	// Ping the database to check if the connection is successful
	err = sqlDB.Ping()
	if err != nil {
		log.Printf("ping db error: %v", err)
		return sqlDB, err
	}
	log.Println("Database connection successful")
	// Perform auto migration
	err = db.AutoMigrate()
	if err != nil {
		log.Printf("auto migrate error: %v", err)
		return sqlDB, err
	}
	log.Println("Auto migration completed")

	return sqlDB, nil
}

func main() {
	postgresConfig := DatabaseConfig{
		Name:     "my_postgres_db",
		Host:     "localhost",
		Port:     5432,
		User:     "postgres",
		Password: "password",
	}

	mysqlConfig := DatabaseConfig{
		Name:     "my_mysql_db",
		Host:     "localhost",
		Port:     3306,
		User:     "root",
		Password: "password",
	}

	sqliteConfig := DatabaseConfig{
		Name: "my_sqlite_db.db",
	}

	mongoConfig := DatabaseConfig{
		Name:     "my_mongo_db",
		Host:     "localhost",
		Port:     6306,
		User:     "root",
		Password: "password",
	}

	mariaConfig := DatabaseConfig{
		Name:     "my_maria_db",
		Host:     "localhost",
		Port:     6306,
		User:     "root",
		Password: "password",
	}

	postgresDB, err := ConnectToPostgreSQL(postgresConfig)
	if err != nil {
		log.Fatal(err)
	}

	mysqlDB, err := ConnectToMySQL(mysqlConfig)
	if err != nil {
		log.Fatal(err)
	}

	sqliteDB, err := ConnectToSQLite(sqliteConfig)
	if err != nil {
		log.Fatal(err)
	}

	mongoDB, err := ConnectToSQLite(mongoConfig)
	if err != nil {
		log.Fatal(err)
	}

	mariaDB, err := ConnectToMaria(mariaConfig)
	if err != nil {
		log.Fatal(err)
	}

	// Now you have connections to all your databases.
}
