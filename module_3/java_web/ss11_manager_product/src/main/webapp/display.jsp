<%--
  Created by IntelliJ IDEA.
  User: TUẤN
  Date: 8/29/2023
  Time: 2:23 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
<html>
<style>
    .navbar-brand{
        font-weight: bold ;
    }
</style>
<body>
<nav class="navbar navbar-expand-lg bg-body-tertiary">
    <div class="container-md">
        <a class="navbar-brand" href="/product?action=showformcreateproduct"><button type="button" class="btn btn-danger">Thêm Sản Phẩm</button></a>
        <a class="navbar-brand" href="/product?action=delete"><button type="button" class="btn btn-danger">Xóa Sản Phẩm</button></a>
        <a class="navbar-brand" href="/product?action=update"><button type="button" class="btn btn-danger">Sửa Sản Phẩm</button></a>
        <a class="navbar-brand" href="/product?action=find"><button type="button" class="btn btn-danger">Tim kiếm Sản Phẩm</button></a>
    </div>
</nav>
<table class="table table-striped">
    <thead>
    <tr>
        <th>STT</th>
        <th>Name</th>
        <th>Price</th>
        <th>Description</th>
        <th>Supplier</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="product" items="${productList}" varStatus="lam">
        <tr>
            <td><c:out value="${lam.count}"/></td>
            <td><c:out value="${product.name}"/></td>
            <td><c:out value="${product.price}"/></td>
            <td><c:out value="${product.description}"/></td>
            <td><c:out value="${product.supplier}"/></td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>
