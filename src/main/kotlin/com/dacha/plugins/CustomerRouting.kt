package com.dacha.plugins

import com.dacha.models.Customer
import io.ktor.application.*
import io.ktor.http.*
import io.ktor.request.*
import io.ktor.response.*
import io.ktor.routing.*
import jetbrains.exodus.entitystore.*

fun Route.customerRouting() {
    route("/customer") {
        get {
            var customer = ""
            PersistentEntityStores.newInstance("./database").use { entityStore ->
                    entityStore.executeInTransaction(
                        StoreTransactionalExecutable { txn: StoreTransaction ->
                            txn.getAll("Customer").forEach { entity ->
                                customer += entity.getProperty("id")
                            }
                        })
                }
            call.respond(customer)
        }
        post {
            val customer = call.receive<Customer>()
            PersistentEntityStores.newInstance("./database").use { entityStore ->
                entityStore.executeInTransaction(
                    StoreTransactionalExecutable { txn: StoreTransaction ->
                        val customerEntity: Entity = txn.newEntity("Customer")
                        customerEntity.setProperty("id", customer.id)
                    })
            }
            call.respondText("Customer stored correctly", status = HttpStatusCode.Created)
        }
    }
}

fun Application.registerCustomerRoutes() {
    routing {
        customerRouting()
    }
}