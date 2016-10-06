@import url(https://fonts.googleapis.com/css?family=Roboto:400,300,700,600);
@import url(https://fonts.googleapis.com/css?family=Lato:400,300);

body {
    background-color: #778899;
    font-family: 'Roboto', sans-serif;
}

ul,ol {
    margin: 0;
    padding: 0;
}

li {
    list-style: none;
}

a {
    color: #FF432E;
    text-decoration: none;
}

a:hover {
    text-decoration: none;
}

p {
    font-family: 'Roboto', sans-serif;
    font-size: 13px;
    line-height: 21px;
}

.company h1 {
    font-family: 'Yatra One', cursive;
    color: #fff;
    font-size: 70px;
}

.company h5 {
    color: #fff;
}

.tile {
    background: #889977;
}

.menu-item {
    color: #fff;
    padding-top: 20px;
    padding-bottom: 20px;
    margin-bottom: 30px;
}

.menu-item a {
    color: #fff;
    display: inline-block;
}

.menu-item a p {
    font-family: 'Lato', sans-serif;
    font-weight: 300;
    font-size: 20px;
}

.menu-item a i {
    font-size: 50px;
    padding-bottom: 20px;
}

.menu-item:hover a {
    text-decoration: none;
    cursor: pointer;
    color: #323232;
    border: 1px thin solid black;
}

.feeds .menu-item {
    height: 250px;
    overflow: auto;
}

.landing {
    padding-top: 50px;
    padding-bottom: 30px;
}

.mention-tag {
    background-color: #997788;
}

.header-tag {
    color: #333 !important;
}

@media only screen 
and (min-width : 600px) 
and (max-width : 991px) {
    
    .menu-item {
        display: inline-block;
        width: 74.8%;
    }
    
    .menu-item.responsive {
        width: 49.5%;
        float: left;
        margin-right: 3px;
    }
    
    .menu-item.responsive-2 {
        width: 49.5%;
        float: right;
    }
    .feeds .menu-item {
        height: 145px;
        overflow: auto;
    }
}

@media only screen 
and (min-width : 992px) 
and (max-width : 1199px) {

    .menu-item {
        padding-top: 15px;
        padding-bottom: 15px;
    }

    .menu-item a i {
        font-size: 32px;
    }

    .menu-item a p {
        font-size: 16px;
    }
    .feeds .menu-item {
        height: 145px;
        overflow: auto;
    }
}

.feature-img {
    margin-bottom: 32px;
}