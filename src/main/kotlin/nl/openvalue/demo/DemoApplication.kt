package nl.openvalue.demo

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@SpringBootApplication
@RestController
class DemoApplication {

	@GetMapping("/hello", "hello")
	fun greet(): ResponseEntity<String> {
		return ResponseEntity.ok("Hello, World!")
	}
}

fun main(args: Array<String>) {
	runApplication<DemoApplication>(*args)
}
