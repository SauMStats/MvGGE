# Test file for utility functions

test_that("validate_inputs works correctly", {
  Y1 <- rnorm(100)
  Y2 <- rbinom(100, 1, 0.3)
  G <- sample(0:2, 100, replace = TRUE)
  E <- rbinom(100, 1, 0.2)
  
  expect_true(validate_inputs(Y1, Y2, G, E))
  
  # Test error conditions
  expect_error(validate_inputs(Y1[1:90], Y2, G, E), "same length")
  expect_error(validate_inputs(Y1, Y2, c(G, 3), E), "0, 1, or 2")
  expect_error(validate_inputs(as.character(Y1), Y2, G, E), "numeric")
})

test_that("is_binary detects binary variables correctly", {
  expect_true(is_binary(c(0, 1, 0, 1, 1)))
  expect_true(is_binary(c(0, 0, 0, 0, 0)))
  expect_false(is_binary(c(0, 1, 2)))
  expect_false(is_binary(c(0.1, 0.9, 0.5)))
  expect_false(is_binary(c("0", "1")))
})

test_that("safe_solve works with regular and singular matrices", {
  # Regular matrix
  A <- matrix(c(4, 2, 2, 3), 2, 2)
  A_inv <- safe_solve(A)
  expect_true(max(abs(A %*% A_inv - diag(2))) < 1e-10)
  
  # Near-singular matrix
  B <- matrix(c(1, 1, 1, 1.0001), 2, 2)
  expect_silent(B_inv <- safe_solve(B))
  expect_true(is.matrix(B_inv))
})

test_that("fast_2x2_inverse works correctly", {
  A <- matrix(c(3, 1, 2, 4), 2, 2)
  A_inv_fast <- fast_2x2_inverse(A)
  A_inv_base <- solve(A)
  
  expect_equal(A_inv_fast, A_inv_base, tolerance = 1e-10)
})

test_that("expit function works correctly", {
  x <- c(-5, 0, 5, 20, -20)
  p <- expit(x)
  
  expect_true(all(p >= 0 & p <= 1))
  expect_equal(p[2], 0.5, tolerance = 1e-10)  # expit(0) = 0.5
  expect_true(p[1] < 0.1)  # expit(-5) should be small
  expect_true(p[3] > 0.9)  # expit(5) should be large
})

test_that("adjust_pvalues works correctly", {
  # Create mock results
  results <- list()
  for (i in 1:5) {
    results[[i]] <- structure(list(
      results = list(p_value = 0.01 * i)
    ), class = "MvGGE_result")
  }
  
  adjusted <- adjust_pvalues(results, method = "BH")
  
  expect_equal(length(adjusted), 5)
  expect_true(all(sapply(adjusted, function(x) !is.null(x$results$p_value_adjusted))))
  expect_equal(adjusted[[1]]$results$adjustment_method, "BH")
})