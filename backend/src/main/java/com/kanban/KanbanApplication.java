package com.kanban;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.mybatis.spring.annotation.MapperScan;

@SpringBootApplication
@MapperScan("com.kanban.mapper")
public class KanbanApplication {
    public static void main(String[] args) {
        SpringApplication.run(KanbanApplication.class, args);
    }
}
