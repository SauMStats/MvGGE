# Test file for edge cases and validation

test_that("Small sample sizes generate warnings", {
  Y1 <- rnorm(15)
  Y2 <- rnorm(15) 
  G <- sample(0:2, 15, replace = TRUE)
  E <- sample(0:1, 15, replace = TRUE)
  
  expect_warning(test_MvGGE(Y1, Y2, G, E), "small")
})

test_that("Missing values are handled correctly", {
  Y1 <- c(rnorm(98), NA, NA)
  Y2 <- c(rnorm(99), NA)
  G <- sample(0:2, 100, replace = TRUE)
  E <- sample(0:1, 100, replace = TRUE)
  
  expect_warning(result <- test_MvGGE(Y1, Y2, G, E), "Missing values")
  expect_equal(result$sample_size, 98)  # Should use complete cases
})

test_that("Monomorphic genotypes generate warnings", {
  Y1 <- rnorm(100)
  Y2 <- rnorm(100)
  G <- rep(0, 100)  # All homozygous
  E <- sample(0:1, 100, replace = TRUE)
  
  expect_warning(test_MvGGE(Y1, Y2, G, E), "zero variance")
})

test_that("Very low MAF generates warnings", {
  Y1 <- rnorm(1000)
  Y2 <- rnorm(1000) 
  G <- c(rep(0, 995), rep(1, 5))  # MAF = 0.0025
  E <- sample(0:1, 1000, replace = TRUE)
  
  expect_warning(test_MvGGE(Y1, Y2, G, E), "Very low minor allele frequency")
})

test_that("Diagnostics function works", {
  set.seed(123)
  data <- simulate_data(n = 100)
  result <- test_MvGGE(data$Y1, data$Y2, data$G, data$E)
  
  diag <- diagnostics(result)
  expect_s3_class(diag, "MvGGE_diagnostics")
  expect_true(diag$analysis_successful)
  expect_true(diag$adequate_sample_size)
})

test_that("S3 methods work correctly", {
  set.seed(123)
  data <- simulate_data(n = 100)
  result <- test_MvGGE(data$Y1, data$Yb2, data$G, data$E)
  
  # Test print method
  expect_output(print(result), "MvGGE Analysis Results")
  
  # Test summary method  
  sum_result <- summary(result)
  expect_s3_class(sum_result, "summary.MvGGE_result")
  expect_output(print(sum_result), "MvGGE Analysis Summary")
  
  # Test coef method (for GEE results)
  if (result$results$method %in% c("GEE-Mixed", "GEE-Binary")) {
    coef_result <- coef(result)
    expect_true(is.data.frame(coef_result) || is.null(coef_result))
  }
})

test_that("Configuration validation works", {
  expect_error(MvGGE_config(max_iterations = -1), "positive integer")
  expect_error(MvGGE_config(convergence_threshold = -1), "positive number")
  expect_error(MvGGE_config(verbose = "yes"), "TRUE or FALSE")
  
  config <- MvGGE_config(verbose = FALSE)
  expect_false(config$verbose)
})