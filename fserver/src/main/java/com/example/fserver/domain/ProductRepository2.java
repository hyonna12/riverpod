package com.example.fserver.domain;

import javax.persistence.EntityManager;

import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Repository
public class ProductRepository2 {

  private final EntityManager em;

  public void findAll() {
    em.createQuery("select p from product", Product.class)
        .getResultList();
    // em.createNativeQuery("select * from product", Product.class)
    // .getResultList();
  }
}
