# Test file for simulation functions

test_that("simulate_data generates correct structure", {
  set.seed(123)
  data <- simulate_data(n = 100, maf = 0.2, f = 0.3)
  
  expect_s3_class(data, "MvGGE_simdata")
  expect_equal(length(data$Y1), 100)
  expect_equal(length(data$Y2), 100)
  expect_equal(length(data$Yb1), 100)
  expect_equal(length(data$Yb2), 100)
  expect_equal(length(data$G), 100)
  expect_equal(length(data$E), 100)
  
  expect_true(all(data$G %in% 0:2))
  expect_true(all(data$E %in% 0:1))
  expect_true(all(data$Yb1 %in% 0:1))
  expect_true(all(data$Yb2 %in% 0:1))
})

test_that("simulate_data respects parameters", {
  set.seed(123)
  data <- simulate_data(n = 1000, maf = 0.25, f = 0.4)
  
  # Check MAF
  observed_maf <- min(mean(data$G)/2, 1 - mean(data$G)/2) 
  expect_true(abs(observed_maf - 0.25) < 0.05)
  
  # Check environmental prevalence  
  observed_f <- mean(data$E)
  expect_true(abs(observed_f - 0.4) < 0.05)
})

test_that("simulate_data input validation works", {
  expect_error(simulate_data(n = -10), "positive integer")
  expect_error(simulate_data(maf = 0.6), "between 0 and 0.5")
  expect_error(simulate_data(f = 1.5), "between 0 and 1")
  expect_error(simulate_data(rho = 2), "between -1 and 1")
  expect_error(simulate_data(beta_g = c(0.1)), "length 2")
})

test_that("simulate_data with seed gives reproducible results", {
  data1 <- simulate_data(n = 50, seed = 456)
  data2 <- simulate_data(n = 50, seed = 456)
  
  expect_equal(data1$Y1, data2$Y1)
  expect_equal(data1$G, data2$G)
  expect_equal(data1$E, data2$E)
})