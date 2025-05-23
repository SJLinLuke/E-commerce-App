//
//  Fragment+OrderConnectionQuery.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import MobileBuySDK

extension Storefront.OrderConnectionQuery {
    
    @discardableResult
    func fragmentForStandardOrder() -> Storefront.OrderConnectionQuery { return self
        .pageInfo { $0
            .hasNextPage()
        }
        .edges { $0
            .cursor()
            .node { $0
                .id()
                .orderNumber()
                .email()
                .totalPrice { $0
                    .amount()
                    .currencyCode()
                }
                .originalTotalDuties { $0
                    .amount()
                    .currencyCode()
                }
                .currentTotalDuties { $0
                    .amount()
                    .currencyCode()
                }
                .totalShippingPrice({ $0
                    .amount()
                    .currencyCode()
                })
                .shippingAddress({ $0
                    .id()
                    .firstName()
                    .lastName()
                    .phone()
                    .address1()
                    .address2()
                    .city()
                    .country()
                    .company()
                    .countryCodeV2()
                    .province()
                    .provinceCode()
                    .zip()
                })
                .processedAt()
                .financialStatus()
                .fulfillmentStatus()
                .lineItems(first: 25) { $0
                    .nodes { $0
                        .title()
                        .quantity()
                        .currentQuantity()
                        .originalTotalPrice {
                            $0.amount()
                        }
                        .variant { $0
                            .id()
                            .title()
                            .image { $0
                                .url()
                            }
                            .compareAtPrice{ $0
                                .amount()
                            }
                            .quantityAvailable()
                            .price { $0
                                .amount()
                                .currencyCode()
                            }
                            .product{ $0
                                .id()
                                .title()
                            }
                            
                        }
                    }
                }
                .discountApplications(first: 250) { $0
                    .edges { $0
                        .node { $0
                            .fragmentForDiscountApplication()
                        }
                    }
                }
            }
        }
    }
}
